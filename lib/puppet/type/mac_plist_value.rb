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

Puppet::Type.newtype(:mac_plist_value) do
    @doc = <<-EOT
        Edit property lists in files on the Mac.

        If the name of the file to edit contains a colon, you must specify it
        using the file parameter, not the title of the resource.

        The file must exist, even if it is empty. You may need to use a file
        resource to make sure the file will exist. This is so that you can be
        sure of the ownership and permissions of a property list file that you
        may be creating.

        Examples:
        
            mac_plist_value { 'meaningless unique name with no colons':
                file => '/path/to/settings.plist',
                key => ['key', 'key2'],
                value => 3,
            }
            mac_plist_value { '/path/to/settings.plist:key/key2':
                value => 3,
            }
            mac_plist_value { '/path/to/settings.plist:key/key2':
                ensure => absent,
            }
            mac_plist_value { '/path/to/settings.plist:key':
                value => { 'key2' => 3, },
            }
            mac_plist_value { '/path/to/a.plist:key/*/otherkey':
                value => 3,
            }
            mac_plist_value { 'meaningless unique name w/o colons':
                file => '/path/to/a.plist',
                key => ['key', '*', 'otherkey'],
                value => 3,
            }
    EOT

    def self.title_patterns
        [
            [/^([^:]+):(.+)$/, [
                [ :file, lambda {|x| x} ],
                [ :key,  lambda {|x| x.split('/') } ]]],
            [/^.*$/, []]]
    end

    newparam(:file) do
        desc "The absolute path of a property list file."
        isnamevar
        isrequired
        newvalues /^\/[^:]*$/
    end

    autorequire(:file) do
        [self[:file]]
    end


    instance_eval &Mac_plist_common_parameters


end
