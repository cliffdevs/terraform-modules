resource aws_api_gateway_domain_name domain {
  domain_name = var.service_domain_name
  regional_certificate_arn = var.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource aws_route53_record alias_record {
  type = "A"
  name = aws_api_gateway_domain_name.domain.domain_name
  zone_id = var.zone_id
  set_identifier = "${aws_api_gateway_domain_name.domain.domain_name}-${var.region}"
  health_check_id = var.health_check_id

  alias {
    evaluate_target_health = false
    name = aws_api_gateway_domain_name.domain.regional_domain_name
    zone_id = aws_api_gateway_domain_name.domain.regional_zone_id
  }

  latency_routing_policy {
    region = var.region
  }
}
