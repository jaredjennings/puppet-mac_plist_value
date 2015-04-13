# CMITS - Configuration Management for Information Technology Systems
# Based on <https://github.com/afseo/cmits>.
# Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require 'puppet'
require 'puppet/type/mac_plist_common_parameters'

Puppet::Type.newtype(:mac_authz_plist_value) do
    @doc = <<-EOT
        Set things in property lists stored in the authorization database.

        Examples:
        
            mac_authz_plist_value { 'meaningless but unique name':
                right => 'system.preferences',
                key => 'shared',
                value => false,
            }
            mac_authz_plist_value { 'system.preferences:shared':
                value => false,
            }
            mac_authz_plist_value { 'meaningless but unique 2':
                right => 'system.login.screensaver',
                key => rule,
                value => ['authenticate-session-owner', ''],
            }
            mac_authz_plist_value { 'system.login.screensaver:rule':
                value => ['authenticate-session-owner', ''],
            }
        
    EOT

    def self.title_patterns
        [
            [/^([^:]+):(.+)$/, [
                [ :right, lambda {|x| x} ],
                [ :key,  lambda {|x| x.split('/') } ]]],
            [/^.*$/, []]]
    end

    newparam(:right) do
        desc "The name of a right in the system authorization database."
        isnamevar
        isrequired
        newvalues /^[^:]*$/
    end

    instance_eval &Mac_plist_common_parameters


end
