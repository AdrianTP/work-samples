class CreateOrganisationsUsers < ActiveRecord::Migration[6.0]
  def up
    # Link Shifts to Organisations _and_ Users
    add_column :shifts, :organisation_id, foreign_key: true

    # Update existing Shifts with reference to correct Organisation
    Shift.all.each do |shift|
      shift.update(organisation_id: shift.user.organisation.id)
    end

    # Create table to link Users and Organisations
    # create_table :organisations_users do |t|
    #   t.references :organisation, foreign_key: true
    #   t.references :user, foreign_key: true

    #   t.timestamps
    # end
    create_join_table :organisations, :users

    # Populate new table with existing links between Users and Organisations
    User.all.each do |user|
      OrganisationsUser.create(user_id: user.id, organisation_id: user.organisation_id)
    end

    # Remove obsolete link to Organisation from Users table
    remove_reference :users, :organisation, foreign_key: true
  end

  def down
    return
    # Cannot be reliably rolled back without potential data loss, but here's
    # approximately how it might happen:

    # Add reference column back
    add_reference :users, :organisation, foreign_key: true

    User.reset_column_information

    # Directly associate each User with one Organisation
    OrganisationsUser.all.each do |organisation_user|
      User.find(organisation_user.user_id)
        .update_attribute(:organisation_id, organisation_user.organisation_id)
    end

    # Remove table linking Organisations to Users
    drop_table :organisations_users

    # Remove Organisation link from Shifts table
    remove_column :shifts, :organisation_id, foreign_key: true
  end
end
