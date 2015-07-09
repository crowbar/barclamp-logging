#
# Copyright 2011-2013, Dell
# Copyright 2013-2014, SUSE LINUX Products GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class LoggingService < ServiceObject

  def initialize(thelogger)
    super(thelogger)
    @bc_name = "logging"
  end

  class << self
    def role_constraints
      {
        "logging-server" => {
          "unique" => true,
          "count" => 1,
          "admin" => true,
          "exclude_platform" => {
            "windows" => "/.*/"
          }
        },
        "logging-client" => {
          "unique" => true,
          "count" => -1,
          "admin" => true
        }
      }
    end
  end

  def create_proposal
    @logger.debug("Logging create_proposal: entering")
    base = super
    @logger.debug("Logging create_proposal: exiting")
    base
  end

  def validate_proposal_after_save proposal
    validate_one_for_role proposal, "logging-server"

    super
  end

  def transition(inst, name, state)
    @logger.debug("Logging transition: entering: #{name} for #{state}")

    #
    # If we are discovering the node, make sure that we add the logging client or server to the node
    #
    if state == "discovered"
      @logger.debug("Logging transition: discovered state for #{name} for #{state}")
      db = Proposal.where(barclamp: "logging", name: inst).first
      role = RoleObject.find_role_by_name "logging-config-#{inst}"

      if role.override_attributes["logging"]["elements"]["logging-server"].nil? or
         role.override_attributes["logging"]["elements"]["logging-server"].empty?
        @logger.debug("Logging transition: make sure that logging-server role is on first: #{name} for #{state}")
        result = add_role_to_instance_and_node("logging", inst, name, db, role, "logging-server")
      else
        node = NodeObject.find_node_by_name name
        unless node.role? "logging-server"
          @logger.debug("Logging transition: make sure that logging-client role is on all nodes but first: #{name} for #{state}")
          result = add_role_to_instance_and_node("logging", inst, name, db, role, "logging-client")
        end
      end

      @logger.debug("Logging transition: leaving from discovered state for #{name} for #{state}")
      a = [200, { :name => name } ] if result
      a = [400, "Failed to add logging role to node"] unless result
      return a
    end

    @logger.debug("Logging transition: leaving for #{name} for #{state}")
    [200, { :name => name } ]
  end

end

