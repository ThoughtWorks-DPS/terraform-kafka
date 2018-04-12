/*
 * Kafka module outputs
 */

output "zk_connect" {
  value = "${join(",", formatlist("%s:2181", aws_instance.zookeeper-server.*.private_ip))}"
}

output "zk_hosts" {
  value = "${aws_instance.zookeeper-server.*.private_ip}"
}
output "kafka_brokers" {
  value = "${aws_instance.kafka-server.*.private_ip}"
}
