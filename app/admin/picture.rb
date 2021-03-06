ActiveAdmin.register Picture do

  filter :title, as: :string

  index do
    selectable_column
    column 'image' do |picture|
       image_tag picture.image.url(:thumb), width: 40, title: picture.image_file_name
    end
    column :title
    column :created_at
    column :updated_at
    default_actions
  end

  filter :email

  form html: { :multipart => true } do |f|
    f.inputs 'Admin Details' do
      f.input :title, as: :string
      f.input :category
      f.input :image, as: :file, hint: f.template.image_tag(f.object.image.url(:thumb))
    end
    f.actions
  end

end