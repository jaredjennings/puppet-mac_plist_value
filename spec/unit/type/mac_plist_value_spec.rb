#!/usr/bin/env/rspec
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

require 'spec_helper'

mac_plist_value = Puppet::Type.type(:mac_plist_value)
describe Puppet::Type.type(:mac_plist_value) do

    it "requires absolute file paths" do
        expect {
            resource = mac_plist_value.new(:title => 'file:key')
        }.to raise_error(Puppet::Error, /Invalid value "file"/)
    end

    it "should split the file and key apart when used as the resource name" do
        resource = mac_plist_value.new(:title => '/file:key')
        resource[:file].should == '/file'
        resource[:key].should == ['key']
    end

    it "doesn't support colons in file names" do
        resource = mac_plist_value.new(:title => '/file:name:key')
        resource[:file].should == '/file'
        resource[:key].should == ['name:key']

        expect {
            resource2 = mac_plist_value.new(
                :title => 'do not care',
                :file => '/file:name',
                :key => 'key')
        }.to raise_error(Puppet::Error, /Invalid value "\/file:name"/)
    end

    it "supports multilevel keys" do
        resource = mac_plist_value.new(:title => '/file:foo/bar/baz')
        resource[:file].should == '/file'
        resource[:key].should == ['foo', 'bar', 'baz']
    end

end
