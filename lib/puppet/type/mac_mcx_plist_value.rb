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

Puppet::Type.newtype(:mac_mcx_plist_value) do
    @doc = <<-EOT
        Set things in property lists stored in the Mac directory service.

        Examples:
        
            mac_mcx_plist_value { 'meaningless but unique name':
                record => '/Computers/host1.example.com',
                key => ['com.example.app', 'mount-controls', 'dvd'],
                mcx_domain => 'always',
                value => { 'zap-sound' => 'blat' },
            }
            mac_mcx_plist_value { "/Computers/host1.example.com:\
                    com.example.app/mount-controls/dvd":
                value => 3,
            }
            mac_mcx_plist_value { 'meaningless unique 2':
                record => '/Computers/host1.example.com',
                key => ['com.example.app', 'mount-controls', 'dvd', 1],
                ensure => absent,
            }
        
    EOT

    def self.title_patterns
        [
            [/^([^:]+):(.+)$/, [
                [ :record, lambda {|x| x} ],
                [ :key,  lambda {|x| x.split('/') } ]]],
            [/^.*$/, []]]
    end

    newparam(:record) do
        desc "The absolute path of a record in the directory service."
        isnamevar
        isrequired
        newvalues /^\/[^:]*$/
    end

    newparam(:mcx_domain) do
        desc <<-EOT
        The type of management applied to the key.

        While dscl allows the "none" MCX domain, we do not here: use ensure =>
        absent instead.
        EOT
        newvalues :always, :once, :often, :unset
        defaultto :always
    end


    instance_eval &Mac_plist_common_parameters


end
