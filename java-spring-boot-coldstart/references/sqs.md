# SQS messaging

Use **Spring Cloud AWS** for SQS. It wraps the AWS SDK v2, gives you `@SqsListener`, and integrates with Boot autoconfiguration.

## Dependencies

Add the BOM and starter to `pom.xml`. The BOM keeps Spring Cloud AWS modules version-aligned with each other.

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>io.awspring.cloud</groupId>
      <artifactId>spring-cloud-aws-dependencies</artifactId>
      <version>3.2.1</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<dependencies>
  <dependency>
    <groupId>io.awspring.cloud</groupId>
    <artifactId>spring-cloud-aws-starter-sqs</artifactId>
  </dependency>
</dependencies>
```

`io.awspring.cloud` (AwsSpring, the community-led project) replaced the legacy Spring Cloud AWS group years ago. Don't add `org.springframework.cloud:spring-cloud-starter-aws` — that's the abandoned version.

## Configuration

```yaml
spring:
  cloud:
    aws:
      region:
        static: us-east-1
      credentials:
        # Production: omit. The default credentials chain (instance role,
        # env vars, ~/.aws/credentials) handles it. Override only for local dev.
        access-key: ${AWS_ACCESS_KEY_ID:}
        secret-key: ${AWS_SECRET_ACCESS_KEY:}
      sqs:
        endpoint: ${SQS_ENDPOINT:}   # set to http://localhost:4566 for LocalStack

app:
  queues:
    orders: orders-incoming
```

## Producing messages

```java
@Service
public class OrderEventPublisher {
    private final SqsTemplate sqsTemplate;
    private final String queueName;

    public OrderEventPublisher(SqsTemplate sqsTemplate,
                               @Value("${app.queues.orders}") String queueName) {
        this.sqsTemplate = sqsTemplate;
        this.queueName = queueName;
    }

    public void publish(OrderCreated event) {
        sqsTemplate.send(to -> to.queue(queueName).payload(event));
    }
}
```

`SqsTemplate` serializes the payload to JSON via the application's `ObjectMapper`. The event class can be a record.

## Consuming messages

```java
@Component
public class OrderEventListener {
    private static final Logger log = LoggerFactory.getLogger(OrderEventListener.class);
    private final OrderProjection projection;

    public OrderEventListener(OrderProjection projection) {
        this.projection = projection;
    }

    @SqsListener("${app.queues.orders}")
    public void onOrderCreated(OrderCreated event) {
        log.info("processing order {}", event.orderId());
        projection.apply(event);
    }
}
```

Key behavior:
- The container polls SQS continuously and dispatches to the method.
- If the method returns normally, the message is **acknowledged** (deleted from the queue).
- If it throws, the message is **not deleted** — SQS will redeliver after the visibility timeout. After `maxReceiveCount` deliveries, AWS sends it to the **DLQ** if one is configured on the queue.

**Configure the DLQ on the queue itself in AWS, not in code.** `maxReceiveCount` belongs in the queue's redrive policy.

## Idempotency

Always assume at-least-once delivery. The same message may arrive twice. Make handlers idempotent:
- Use the event's natural ID (e.g. `orderId`) as a dedupe key.
- Check "already processed?" before applying side effects.
- For outbound calls, prefer idempotent operations or pass an idempotency key.

## Error handling

For known transient failures (timeouts, 503s), re-throw — let SQS redeliver. For poison messages (malformed, business-invalid) the redrive-to-DLQ behavior is what you want; don't silently swallow them.

To customize the container (concurrency, batch size, visibility), define a `SqsMessageListenerContainerFactory` bean. Default factory is fine for most use cases.

## Local dev: LocalStack

Run LocalStack via Docker, point `spring.cloud.aws.sqs.endpoint` at it, and create the queue at startup:

```bash
docker run --rm -p 4566:4566 localstack/localstack
aws --endpoint-url http://localhost:4566 sqs create-queue --queue-name orders-incoming
```

For tests, prefer Testcontainers' `LocalStackContainer` — see [testing.md](testing.md).
