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

      it 'returns issue' do
        expect(Issue).to receive(:find).with(action.issue_id)
        action.issue
      end
    end

    context 'issue id is not defined' do
      let(:action) { build(:action, issue_id: nil) }

      it 'returns nil' do
        expect(action.issue).to be_nil
      end
    end
  end

  describe '#activity' do
    context 'activity id is defined' do
      let(:action) { build(:action) }
      let(:activity) { build(:time_entry_activity, id: action.activity_id) }

      it 'returns activity' do
        expect(TimeEntryActivity).to receive(:find_by_id)
          .with(action.activity_id)
        action.activity
      end
    end

    context 'activity id is not defined' do
      let(:action) { build(:action, activity_id: nil) }

      it 'returns nil' do
        expect(action.activity).to be_nil
      end
    end
  end

  describe '#start' do
    before { Timecop.freeze started_at }
    after { Timecop.return }

    let(:started_at) { Time.new(2016, 6, 1, 12, 30, 0) }
    let(:action) { build(:action) }

    it 'sets started_at and erase stopped_at' do
      action.start
      expect(action.started_at).to eq started_at
      expect(action.stopped_at).to be_nil
    end
  end

  describe '#stop' do
    before { Timecop.freeze stopped_at }
    after { Timecop.return }

    let(:stopped_at) { Time.new(2016, 6, 1, 12, 30, 0) }
    let(:action) { build(:action, started_at: Time.new(2016, 6, 1, 10, 0, 0)) }

    it 'sets stopped_at and increase spent_on' do
      action.stop
      expect(action.stopped_at).to eq stopped_at
      expect(action.spent_on).to eq 2.5
    end
  end

  describe '#time_from_start' do
    context 'started_at is nil' do
      let(:action) { build(:action) }

      it 'returns 0.0' do
        expect(action.time_from_start).to eq 0.0
      end
    end

    context 'started_at is not nil' do
      before { Timecop.freeze Time.new(2016, 6, 1, 12, 30, 0) }
      after { Timecop.return }

      let(:action) do
        build(:action, started_at: Time.new(2016, 6, 1, 10, 0, 0))
      end

      it 'returns time from start' do
        expect(action.time_from_start).to eq 2.5
      end
    end
  end

  describe '#spent_from_start' do
    context 'started_at or stopped_at is nil' do
      let(:action) { build(:action) }

      it 'returns 0.0' do
        expect(action.spent_from_start).to eq 0.0
      end
    end

    context 'started_at and stopped_at is not nil' do
      let(:action) do
        build(:action, started_at: Time.new(2016, 6, 1, 10, 0, 0),
                       stopped_at: Time.new(2016, 6, 1, 12, 30, 0))
      end

      it 'returns time spent from start' do
        expect(action.spent_from_start).to eq 2.5
      end
    end
  end
end
