require 'green_shoes'

class Application < Shoes
  url '/', :show
  url '/new', :new
  url '/edit', :edit

  @user = User.current
  @action_id = nil
  @action = nil
  Action.store.create(Action.table) unless Action.store.exists?(Action.table)

  class << self
    attr_accessor :user, :action_id, :action
  end

  def show
    self.class.action = Action.find(self.class.action_id)
    template do
      show_content
      show_footer
    end
  end

  def new
    self.class.action = Action.new
    template do
      edit_content
      edit_footer
    end
  end

  def edit
    self.class.action = Action.find(self.class.action_id)
    template do
      edit_content
      edit_footer
    end
  end

  protected

  def show_footer
    flow width: 450, height: 50 do
      border black
      if self.class.action.present?
        button 'Edit', width: 450, height: 50 do
          Application.APPS.first.clear
          visit '/edit'
        end
      end
    end
  end

  def show_content
    stack width: 450, height: 510 do
      if self.class.action.present?
        para "Project: #{self.class.action.project.name}",
             margin_top: 10, margin_left: 10
        para "Issue: #{self.class.action.issue.subject}",
             margin_left: 10

        @started_at_timer = title self.class.action.time_from_start,
                                  align: 'center', size: 100
        @created_at_timer = caption self.class.action.spent_on,
                                    align: 'center', size: 40, stroke: gray
        every(5) do
          @started_at_timer.replace self.class.action.time_from_start
          @created_at_timer.replace self.class.action.spent_on
        end
      end
    end
  end

  def edit_content
    @projects_map = Hash[*Project.all.map { |p| [p.name, p.id] }.flatten]
    self.class.action.project_id ||= @projects_map.values.first
    self.class.action.project_id = @projects_map.values.first if @projects_map[self.class.action.project.try(:name)].nil?

    issues = Issue.where(project_id: self.class.action.project_id)
    @issues_map = Hash[*issues.map { |i| [i.subject, i.id] }.flatten]
    self.class.action.issue_id ||= @issues_map.values.first
    self.class.action.issue_id = @issues_map.values.first if @issues_map[self.class.action.issue.try(:subject)].nil?

    stack width: 450, height: 510 do
      @edit_line = edit_line width: 400, text: self.class.action.name do |edit|
        self.class.action.name = edit.text
      end
      para 'Project: ', margin_top: 10, margin_left: 10
      list_box(width: 400, items: @projects_map.keys,
               choose: self.class.action.project.try(:name)) do |list|
        self.class.action.project_id = @projects_map[list.text]
        issues = Issue.where(project_id: @projects_map[list.text])
        @issues_map = Hash[*issues.map { |i| [i.subject, i.id] }.flatten]
        @issues_list.items = @issues_map.keys
        @issues_list.choose(@issues_map.keys.first)
      end

      para 'Issue: ', margin_top: 10, margin_left: 10
      @issues_list = list_box(width: 400, items: @issues_map.keys,
                              choose:
                                self.class.action.issue.try(:subject)) do |list|
        self.class.action.issue_id = @issues_map[list.text]
      end
    end
  end

  def edit_footer
    flow width: 450, height: 50 do
      border black
      button 'Cancel', width: 200, height: 50 do
        visit '/'
      end
      button 'Save', width: 200, height: 50, margin_left: 50 do
        self.class.action.save
        self.class.action_id = self.class.action.id
        Application.APPS.first.clear
        Application.APPS.first.
        visit '/'
      end
    end
  end

  def template
    flow width: '100%', height: '100%' do
      sidebar
      stack width: 450, height: 600 do
        header
        yield
      end
    end
  end

  def header
    flow width: 450, height: 40 do
      border black
      if self.class.action.present?
        caption self.class.action.name, margin_top: 5, align: 'center'
      end
    end
  end

  def sidebar
    stack width: 350, height: '100%' do
      user
      actions
      flow width: 350, height: 50 do
        border black
        button 'Add', width: 350, height: 50 do
          visit '/new'
        end
      end
    end
  end

  def user
    stack width: 350, height: 80 do
      border black
      caption self.class.user.name, align: 'center', margin_top: 20
      para self.class.user.mail, stroke: gray, align: 'center'
    end
  end

  def actions
    c = self
    stack width: 350, height: 470 do
      stack width: 350, height: 470, top: 80, scroll: true do
        border black
        Action.all.each do |action|
          button(action.name, width: 350, height: 50) do
            Application.action_id = action.id
            c.visit '/'
          end
        end
        flush
      end
    end
  end
end
