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

require 'spec_helper'
require 'openstudio'
require_relative '../spec_helper'

RSpec.describe 'OpenStudio::Metadata::Writer Haystack and Brick SmallOffice spec' do
  before(:all) do
    @building_type = 'SmallOffice'
    @dir = "#{Dir.pwd}/spec/outputs/#{@building_type}"
    check_and_create_prototype(@building_type)
    @model = OpenStudio::Model::Model.load(@dir + '/SR1/in.osm').get
    @mappings_manager = OpenStudio::Metadata::Mapping::MappingsManager.new
    @output_path = File.join(File.dirname(__FILE__), '../outputs')

    @translator = OpenStudio::Metadata::Translator.new(@model, @mappings_manager)
    @entities = @translator.build_entities_list
    @writer = OpenStudio::Metadata::Writer.new
  end

  it 'Should be able to write a Brick graph to a turtle file' do
    @writer.create_output(@entities)
    n = "#{@building_type}_model.ttl"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'ttl', output_schema: OpenStudio::Metadata::BRICK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end

  it 'Should be able to write a Brick graph to an nquads file' do
    n = "#{@building_type}_model.nq"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'nq', output_schema: OpenStudio::Metadata::BRICK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end

  it 'Should be able to write a Haystack model to a json file' do
    @writer.create_output(@entities)
    n = "#{@building_type}_model.json"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'json', output_schema: OpenStudio::Metadata::HAYSTACK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end
end

RSpec.describe 'OpenStudio::Metadata::Writer Haystack and Brick MediumOffice spec' do
  before(:all) do
    @building_type = 'MediumOffice'
    @dir = "#{Dir.pwd}/spec/outputs/#{@building_type}"
    check_and_create_prototype(@building_type)
    @model = OpenStudio::Model::Model.load(@dir + '/SR1/in.osm').get
    @mappings_manager = OpenStudio::Metadata::Mapping::MappingsManager.new
    @output_path = File.join(File.dirname(__FILE__), '../outputs')

    @translator = OpenStudio::Metadata::Translator.new(@model, @mappings_manager)
    @entities = @translator.build_entities_list
    @writer = OpenStudio::Metadata::Writer.new
  end

  it 'Should be able to write a Brick graph to a turtle file' do
    @writer.create_output(@entities)
    n = "#{@building_type}_model.ttl"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'ttl', output_schema: OpenStudio::Metadata::BRICK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end

  it 'Should be able to write a Brick graph to an nquads file' do
    n = "#{@building_type}_model.nq"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'nq', output_schema: OpenStudio::Metadata::BRICK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end

  it 'Should be able to write a Haystack model to a json file' do
    @writer.create_output(@entities)
    n = "#{@building_type}_model.json"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'json', output_schema: OpenStudio::Metadata::HAYSTACK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end
end

RSpec.describe 'OpenStudio::Metadata::Writer Haystack and Brick RetailStandalone spec' do
  before(:all) do
    @building_type = 'RetailStandalone'
    @dir = "#{Dir.pwd}/spec/outputs/#{@building_type}"
    check_and_create_prototype(@building_type)
    @model = OpenStudio::Model::Model.load(@dir + '/SR1/in.osm').get
    @mappings_manager = OpenStudio::Metadata::Mapping::MappingsManager.new
    @output_path = File.join(File.dirname(__FILE__), '../outputs')

    @translator = OpenStudio::Metadata::Translator.new(@model, @mappings_manager)
    @entities = @translator.build_entities_list
    @writer = OpenStudio::Metadata::Writer.new
  end

  it 'Should be able to write a Brick graph to a turtle file' do
    @writer.create_output(@entities)
    n = "#{@building_type}_model.ttl"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'ttl', output_schema: OpenStudio::Metadata::BRICK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end

  it 'Should be able to write a Brick graph to an nquads file' do
    n = "#{@building_type}_model.nq"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'nq', output_schema: OpenStudio::Metadata::BRICK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end

  it 'Should be able to write a Haystack model to a json file' do
    @writer.create_output(@entities)
    n = "#{@building_type}_model.json"
    f = File.join(@output_path, n)
    if File.exist?(f)
      File.delete(f)
    end
    expect(File.exist?(f)).to be false
    @writer.write_output_to_file(output_format: 'json', output_schema: OpenStudio::Metadata::HAYSTACK, file_path: @output_path, file_name_without_extension: n.split('.')[0])
    expect(File.exist?(f)).to be true
  end
end
