/*
 * Kafka data
 */

data "aws_subnet" "subnet" {
  count = "${length(var.subnet_ips)}"
  id = "${var.subnet_ids[count.index]}"
}

data "aws_subnet" "static-subnet" {
  count = "${length(var.subnet_ips)}"
  id = "${var.static_subnet_ids[count.index]}"
}
