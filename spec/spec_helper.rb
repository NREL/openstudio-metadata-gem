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

require 'bundler/setup'
require 'openstudio'
require 'openstudio-standards'
require 'openstudio/alfalfa'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.formatter = :documentation

  def check_and_create_small_office
    osm_dir = "#{Dir.pwd}/spec/outputs/small_office"
    sr_dir = osm_dir + '/SR1'
    osm = sr_dir + '/in.osm'
    # Check first whether the directories exist
    if !File.exist?(osm)
      model = OpenStudio::Model::Model.new
      epw_file = nil
      building_type = 'SmallOffice'
      template = '90.1-2013'
      cz = 'ASHRAE 169-2013-5A'
      if !Dir.exist?(osm_dir)
        FileUtils.mkdir_p(osm_dir)
      end
      prototype_creator = Standard.build("#{template}_#{building_type}")
      prototype_creator.model_create_prototype_model(cz, epw_file, osm_dir, false, model)
    else
      puts 'SmallOffice model already exists, will use existing'
    end
  end

  def count_class_mappings(creator)
    count_by_class = {}
    total_count = 0
    creator.mappings.each do |map|
      c = map['openstudio_class']
      objects = creator.model.getObjectsByType(c)
      count_by_class[c] = objects.size
      total_count += objects.size
    end
    return [count_by_class, total_count]
  end

  def setup_creator_small_office(metadata_type)
    types = ['Brick', 'Haystack']
    raise "metadata_type must be one of #{types}" unless types.include? metadata_type
    @small_office_dir = "#{Dir.pwd}/spec/outputs/small_office"
    @small_office_osm = @small_office_dir + '/SR1/in.osm'

    @creator = OpenStudio::Alfalfa::Creator.new(@small_office_osm)
    @creator.read_templates_and_mappings
    @creator.read_metadata
    @creator.apply_mappings(metadata_type)
    return @creator
  end
end
