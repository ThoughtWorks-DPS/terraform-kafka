/*
 * Kafka instances
 */

resource "aws_instance" "zookeeper-server" {
  count = "${data.aws_subnet.static-subnet.count}"
  ami = "${var.zookeeper_ami}"
  instance_type = "${var.zookeeper_instance_type}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  subnet_id = "${var.static_subnet_ids[count.index]}"
  private_ip = "${cidrhost(element(data.aws_subnet.static-subnet.*.cidr_block, count.index), var.zookeeper_addr)}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.key_name}"
  tags   = "${merge(var.common_tags, map("Name",format("%s-%s-zk-%02d",var.environment, var.app_name, count.index+1)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "kafka-server" {
  count = "${var.brokers_per_az * data.aws_subnet.subnet.count}"
  ami = "${var.kafka_ami}"
  instance_type = "${var.kafka_instance_type}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  subnet_id = "${var.subnet_ids[count.index % data.aws_subnet.subnet.count]}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.key_name}"
  user_data = "${data.template_file.mount-volumes.rendered}"
  tags   = "${merge(var.common_tags, map("Name",format("%s-%s-kafka-%02d",var.environment, var.app_name, count.index+1)))}"
}
