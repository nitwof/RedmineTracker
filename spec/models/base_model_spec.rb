require 'spec_helper'
require 'support/model'
require 'models/base_model'

describe BaseModel do
  include_examples 'model', BaseModel
end
