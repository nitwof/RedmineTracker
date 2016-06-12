require 'spec_helper'
require 'support/factory_girl'
require 'support/model'

describe Action do
  include_examples 'model', Action

  it 'inherits BaseModel' do
    expect(Action).to be < BaseModel
  end

  describe '#project' do
    context 'project id is defined' do
      let(:action) { build(:action) }
      let(:project) { build(:project, id: action.project_id) }

      it 'returns project' do
        expect(Project).to receive(:find).with(action.project_id)
        action.project
      end

      # it 'cashes project' do
      #   expect(Project).to receive(:find)
      #     .with(action.project_id).and_return(project)
      #   action.project
      #   expect(Project).not_to receive(:find)
      #   expect(action.project).to eq project
      # end
    end

    context 'project id is not defined' do
      let(:action) { build(:action, project_id: nil) }

      it 'returns nil' do
        expect(action.project).to be_nil
      end
    end
  end

  describe '#issue' do
    context 'issue id is defined' do
      let(:action) { build(:action) }
      let(:issue) { build(:issue, id: action.issue_id) }

      it 'returns project' do
        expect(Issue).to receive(:find).with(action.issue_id)
        action.issue
      end

      # it 'cashes project' do
      #   expect(Issue).to receive(:find).with(action.issue_id).and_return(issue)
      #   action.issue
      #   expect(Issue).not_to receive(:find)
      #   expect(action.issue).to eq issue
      # end
    end

    context 'issue id is not defined' do
      let(:action) { build(:action, issue_id: nil) }

      it 'returns nil' do
        expect(action.issue).to be_nil
      end
    end
  end
end
