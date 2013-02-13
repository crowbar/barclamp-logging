# Copyright 2013, Dell
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

if Barclamp.table_exists?
  bc = Barclamp.find_by_name("logging")
  raise "Logging barclamp data is not installed in database (barclamps)" unless bc
  BarclampLogging::API_VERSION=(bc && bc.api_version || "v1")
  BarclampLogging::API_VERSION_ACCEPTS=(bc && bc.api_version_accepts || "v1")
else
  # migrations not run, yet...
  BarclampLogging::API_VERSION="v1"
  BarclampLogging::API_VERSION_ACCEPTS="v1"
end
