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
Mac_plist_common_parameters = Proc.new do
    ensurable do
        defaultvalues
        defaultto :present
    end

    newparam(:key) do
        desc <<-EOT
            The preference key within the file.
            
            Multiple values for the key parameter, or slash-separated path
            elements after the colon in the resource name, are treated as keys
            to nested dictionaries; so
        
                key => ['key', 'key2']
        
            assumes that we are editing a property list that's already shaped
            like this:

                { "key" => { "key2" => 8 } }

            Multiple values are used as keys in successive depths of
            dictionaries.

            Keys with slashes in their names are not supported. (On a Snow
            Leopard Mac in 2013, 19 of the 1720 property names I could find had
            slashes, about 1.1%.)

            If one of the values of the key is '*', multiple values may be set
            or deleted, one for each possible key at that level of the property
            list.
        EOT

        isnamevar
        isrequired
        newvalues /^[^:\/].*/
        munge do |value|
            value = [value] unless value.is_a?(Array)
            value
        end
    end

    newparam(:value) do
        desc <<-EOT
            The intended value for the given key in the given property list
            file.

            Values may be coerced to whatever they look like, so true and false
            will end up as booleans, values comprised entirely of digits will
            likely end up as integers, etc.

            Puppet treats arrays containing a single value specially (see
            http://projects.puppetlabs.com/issues/15813), so to specify a value
            which should be an array and should contain one thing, add an empty
            string to the end of the array. Like
            
                value => ['thing i wanted', '']

            The empty string will be stripped off at the proper time. If you
            find yourself in the unlikely case of needing an empty string at
            the end of an array value, simply give two empty strings. Like

                value => ['next is an empty', '', '']

            The last empty string will be stripped off, but the second-to-last
            will remain.

        EOT

        # Default to something that's not nil, so ensure => absent will work. I
        # forgot exactly how it works, but when parameters have nil values,
        # that means something to Puppet besides "this parameter's value is
        # nil," like "meh, don't bother to do anything" or something.
        defaultto :true
        munge do |v|
            case v
            when :true; true
            when :false; false
            else v
            end
        end
    end
end
