ActiveAdmin.register Demerit do
  includes user: :rank
  includes author: :rank

  permit_params :date, :member_id, :reason, :forum_id, :topic_id

  filter :user, collection: -> { User.active.includes(:rank).order(:last_name) }
  filter :date
  filter :reason_cont

  config.sort_order = 'date_desc'

  index do
    selectable_column
    column :date
    column :user
    column :author
    column :reason do |demerit|
      demerit.reason.truncate 75, omission: '…'
    end
    actions
  end

  show do
    attributes_table do
      row :date
      row :user
      row :author
      row :reason
      row :forum_id
      row :topic_id
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :date
      f.input :user, as: :select, collection: User.active.includes(:rank).order(:last_name)
      f.input :reason
      f.input :forum_id, as: :select, collection: Demerit.forum_ids.map(&:reverse)
      f.input :topic_id, label: 'Topic ID'
    end
    f.actions
  end

  before_create do |demerit|
    demerit.author = current_user
  end
end
