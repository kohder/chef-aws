#
# Cookbook Name:: aws
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

r = gem_package "right_aws" do
  version node['aws']['right_aws_version']
  action :nothing
end

r.run_action(:install)

require 'rubygems'
Gem.clear_paths
require 'right_aws'

# Manage AWS access keys as requested via node attributes (done immediately)
aws_access_keys_entries = node['aws']['access_keys']
unless aws_access_keys_entries.nil?
  aws_access_keys_entries.each do |name, attributes|
    act = attributes.delete('action') || :set
    aws_access_keys name do
      attributes.each do |k, v|
        self.send(k.to_sym, v)
      end
      action :nothing
    end.run_action(act)
  end
end
