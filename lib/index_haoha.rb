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
# Follow a path of indices through a hash or array of hashes or arrays.
# (Pronounced "IN dex HOW huh.")
# 
# When Mac property lists are read as NSDictionaries and converted using the
# to_ruby method, as far as I know they are composed only of boring collection
# types, like Hash and Array. Furthermore, numbers and strings are indexable in
# Ruby 1.8.7, but it's most likely that if you are modifying a Mac property
# list, you want to change a whole number or string, not a bit or character
# inside it. So, we'll violate the principle of duck typing by refusing to
# index something that is neither a Hash nor an Array. 
def index_haoha tree, path, &block
    if path.empty?
        yield tree
    else
# Since we're supporting wildcards here, therefore multiple paths and possibly
# multiple matches, we don't want one failure to halt the traversal, so we just
# do nothing rather than error out.
      if tree.is_a?(Hash) or tree.is_a?(Array)
            if path[0] == '*'
                tree.each do |thing|
                    # for Hashes, thing is like [key, value]
                    thing = thing[-1] if thing.is_a? Array
                    index_haoha thing, path[1..-1], &block
                end
            else
                index_haoha tree[path[0]], path[1..-1], &block
            end
        end
    end
end

def index_haoha_or_fail tree, path, &block
    arrived_at_least_once = false
    index_haoha(tree, path) do |x|
        yield x
        arrived_at_least_once = true
    end
    raise IndexError, "Could not find any matches " \
            "for path #{path.inspect}" unless arrived_at_least_once
end

def mkhashp hash, path
    if path.any?
        hash[path[0]] ||= {}
        mkhashp hash[path[0]], path[1..-1]
    end
end
