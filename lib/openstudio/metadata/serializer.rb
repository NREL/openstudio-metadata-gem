# *******************************************************************************
# OpenStudio(R), Copyright (c) 2008-2020, Alliance for Sustainable Energy, LLC.
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# (1) Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# (2) Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# (3) Neither the name of the copyright holder nor the names of any contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission from the respective party.
#
# (4) Other than as required in clauses (1) and (2), distributions in any form
# of modifications or other derivative works may not use the "OpenStudio"
# trademark, "OS", "os", or any other confusingly similar designation without
# specific prior written permission from Alliance for Sustainable Energy, LLC.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) AND ANY CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER(S), ANY CONTRIBUTORS, THE
# UNITED STATES GOVERNMENT, OR THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF
# THEIR EMPLOYEES, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# *******************************************************************************
require 'rdf'
require 'linkeddata'
require 'sparql/client'

module OpenStudio
  module Metadata
    class BrickGraph
      attr_reader :g

      def initialize(building_namespace: 'http://example.com/mybuilding#')
        @brick = RDF::Vocabulary.new('https://brickschema.org/schema/1.1/Brick#')
        @bldg = RDF::Vocabulary.new(building_namespace)
        @prefixes = {
          rdf: RDF.to_uri,
          rdfs: RDF::RDFS.to_uri,
          brick: @brick,
          bldg: @bldg
        }
        @g = RDF::Repository.new
      end

      def create_graph_from_entities(entities)
        entities.each do |entity|
          @g << RDF::Statement.new(@bldg[entity['id']], RDF.type, @brick[entity['type']])
          @g << RDF::Statement.new(@bldg[entity['id']], RDF::RDFS.label, entity['dis'])
          if entity.key? 'relationships'
            entity['relationships'].each do |relationship, reference|
              @g << RDF::Statement.new(@bldg[entity['id']], @brick[relationship], @bldg[reference])
            end
          end
        end
      end

      def dump(format = :ttl)
        return @g.dump(format, prefixes: @prefixes)
      end
    end
    class Haystack
      def create_haystack_from_entities(entities)
        cols = []
        rows = []
        entities.each do |entity|
          entity.keys.each do |k|
            if k == 'add_tags'
              (tags = entity[k]) && tags.each { |tag| entity.store(tag, ':m') && entity.delete(k) }
            elsif k == 'type'
              (t_tags = entity[k].split('-')) && t_tags.each { |t_tag| entity.store(t_tag, ':m') } && entity.delete(k)
            elsif k == 'relationships'
              relationships = entity[k]
              relationships.each do |relationship, reference|
                entity.store(relationship, reference)
              end
              entity.delete(k)
            end
          end
          rows.append(entity)
        end
        rows.each do |row|
          row.keys.each do |k|
            unless cols.include?('name' => k)
              cols.append('name' => k)
            end
          end
        end
        data = { 'meta' => { 'ver' => '3.0' },
                 'cols' => cols,
                 'rows' => rows }
        return JSON.pretty_generate(data)
      end
    end
  end
end