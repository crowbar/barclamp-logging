
name "logging-server"
description "Logging Servier Role - Logging master for the cloud"
run_list(
         "recipe[logging::server]"
)
default_attributes "logging" => {
  "external_servers" => [ ],
  "config" => { "environment" => "logging-base-config" }
}
override_attributes()

