# Copyright 2012, Dell 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 

class LoggingService < ServiceObject

  def transition(inst, name, state)
    @logger.debug("Logging transition: entering: #{name} for #{state}")

    #
    # If we are discovering the node, make sure that we add the logging client or server to the node
    #
    if state == "discovered"
      @logger.debug("Logging transition: discovered state for #{name} for #{state}")

      prop = @barclamp.get_proposal(inst)
      return [400, "Logging Proposal is not active"] unless prop.active?

      nodes = prop.active_config.get_nodes_by_role("logging-server")
      if nodes.empty?
        @logger.debug("Logging transition: make sure that logging-server role is on first: #{name} for #{state}")
        result = add_role_to_instance_and_node(name, inst, "logging-server")
        nodes = [ Node.find_by_name(name) ]
      else
        node = Node.find_by_name name
        unless nodes.include? node
          @logger.debug("Logging transition: make sure that logging-client role is on all nodes but first: #{name} for #{state}")
          result = add_role_to_instance_and_node(name, inst, "logging-client")
        end
      end

      @logger.debug("Logging transition: leaving from discovered state for #{name} for #{state}")
      a = [200, ""] if result
      a = [400, "Failed to add logging role to node"] unless result
      return a
    end

    @logger.debug("Logging transition: leaving for #{name} for #{state}")
    [200, ""]
  end

end

