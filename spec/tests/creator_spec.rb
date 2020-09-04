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
require_relative '../spec_helper'

RSpec.describe 'OpenStudio::Alfalfa::Creator Haystack and Brick Small Office spec' do
  before(:all) do
    @small_office_dir = "#{Dir.pwd}/spec/outputs/small_office"
    @small_office_osm = @small_office_dir + '/SR1/in.osm'
    check_and_create_small_office

    @model = OpenStudio::Model::Model.load(@small_office_osm)
    @model = @model.get
    @creator = OpenStudio::Alfalfa::Creator.new(@model)
  end

  it 'Should read in templates and mappings' do
    @creator.read_templates_and_mappings
    expect(@creator.templates).not_to be nil
    expect(@creator.mappings).not_to be nil
  end

  it 'Should read in brick and haystack metadata definitions' do
    @creator.read_metadata
    expect(@creator.haystack_repo).to_not be nil
    expect(@creator.brick_repo).to_not be nil
    # puts @creator.haystack_ttl.to_ttl
  end

  it 'Should have heatPump as a term in @haystack_repo' do
    expect(@creator.haystack_repo.has_subject?(@creator.phiot_vocab.heatPump)).to be true
  end

  it 'Should have AHU as a term in @brick_repo' do
    expect(@creator.brick_repo.has_subject?(@creator.brick_vocab['AHU'])).to be true
  end

  it "Should return four Haystack classes that are subclasses of an 'ahu'" do
    s = SPARQL::Client.new(@creator.haystack_repo)
    q = "SELECT ?e WHERE { ?e <#{RDF::RDFS.subClassOf}>* <#{@creator.phiot_vocab.ahu}> }"
    results = s.query(q)
    data = []
    results.each do |r|
      data << r['e'].to_s
    end
    data = data.to_set
    expect(data.size).to be 4
    expected = [
      @creator.phiot_vocab.ahu.to_s,
      @creator.phiot_vocab['doas'].to_s,
      @creator.phiot_vocab[:rtu].to_s,
      @creator.phiot_vocab.mau.to_s
    ]
    expected = expected.to_set
    expect(expected == data).to be true
  end

  it 'Should store templates as an array' do
    expect(@creator.templates).to be_an_instance_of(Array)
  end

  it 'Should store mappings as an array' do
    expect(@creator.mappings).to be_an_instance_of(Array)
  end

  it 'Should assert that all templates have an id' do
    @creator.templates.each do |template|
      expect(template).to have_key('id')
    end
  end

  it 'Should assert that all mappings define an openstudio_class key' do
    @creator.mappings.each do |mapping|
      expect(mapping).to have_key('openstudio_class')
    end
  end

  it 'Should apply mappings for Haystack entities' do
    # TODO: check count by class
    expect(@creator.entities.size).to eq 0
    @creator.apply_mappings('Haystack')
    # puts @creator.entities
    @creator.entities.each do |e|
      expect(e).to have_key('id')
      expect(e).to have_key('dis')
      expect(e).to have_key('type')
    end
    count_by_class, total_count = count_class_mappings(@creator)
    expect(@creator.entities.size).to eq total_count
  end

  it 'Should apply mappings for Brick entities' do
    # TODO: check count by class
    @creator.entities = []
    expect(@creator.entities.size).to eq 0
    @creator.apply_mappings('Brick')
    # puts @creator.entities
    @creator.entities.each do |e|
      expect(e).to have_key('id')
      expect(e).to have_key('dis')
      expect(e).to have_key('type')
    end
    count_by_class, total_count = count_class_mappings(@creator)
    expect(@creator.entities.size).to eq total_count
  end

end
