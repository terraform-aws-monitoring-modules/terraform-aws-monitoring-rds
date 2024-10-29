locals {
  rds_db_instance_events = concat(var.rds_db_instance_events, var.rds_db_parameter_group_events, var.rds_db_security_group_events)
  rds_db_cluster_events  = concat(var.rds_db_cluster_events, var.rds_db_parameter_group_events, var.rds_db_security_group_events)
}

resource "aws_cloudwatch_log_metric_filter" "rds_metric_filter" {
  count          = length(var.rds_db_identifiers)
  log_group_name = var.cw_log_group_name
  name           = "${var.rds_db_identifiers[count.index]}-metric-filter"
  pattern        = var.rds_db_type == "instance" ? "{ ($.eventSource = rds.amazonaws.com) && ($.requestParameters.dBInstanceIdentifier = \"${var.rds_db_identifiers[count.index]}\") && ($.eventName = \"${join("\" || $.eventName = \"", local.rds_db_instance_events)}\") }" : "{ ($.eventSource = rds.amazonaws.com) && ($.requestParameters.dBClusterIdentifier = \"${var.rds_db_identifiers[count.index]}\") && ($.eventName = \"${join("\" || $.eventName = \"", local.rds_db_cluster_events)}\") }"

  metric_transformation {
    name      = "${var.rds_db_identifiers[count.index]}-metric-filter"
    namespace = var.cw_metric_filter_namespace
    value     = var.cw_metric_filter_value
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_metric_filter_alarm" {
  count               = length(var.rds_db_identifiers)
  alarm_name          = "${var.rds_db_identifiers[count.index]}-metric-filter-alarm"
  comparison_operator = var.cw_metric_filter_alarm_comparison_operator
  evaluation_periods  = var.cw_metric_filter_alarm_evaluation_periods
  metric_name         = "${var.rds_db_identifiers[count.index]}-metric-filter"
  namespace           = var.cw_metric_filter_namespace
  period              = var.cw_metric_filter_alarm_period
  statistic           = var.cw_metric_filter_alarm_statistic
  threshold           = var.cw_metric_filter_alarm_threshold
  alarm_description   = "Alarm when RDS ${var.rds_db_identifiers[count.index]} exceeds the specified threshold."
  alarm_actions       = var.cw_metric_filter_alarm_actions
}
