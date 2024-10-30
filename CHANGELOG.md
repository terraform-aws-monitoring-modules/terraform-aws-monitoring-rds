# Changelog

## [1.0.0] - 2024-10-30

### Added
- Initial release of the RDS Monitoring module.
- Support for monitoring Amazon RDS databases with custom metric filters and alarms.
- Configurable parameters for RDS database identifiers, event names, and CloudWatch log settings.
- Automatic creation of CloudWatch metric filters based on specified RDS databases and their respective events.
- Alarms triggered based on defined thresholds for the specified metrics.
- Detailed variable descriptions for easy customization and configuration.

### Changed
- Updated Terraform examples in [`README.md`](README.md) to reference the module source from the Terraform Registry.
