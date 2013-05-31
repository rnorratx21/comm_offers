class PopulateRoles < ActiveRecord::Migration
  def self.up
    unless Group.find_by_name("Default")
      Group.create! :name => "Default"
    end
    unless Group.find_by_name("Global")
      Group.create! :name => "Global"
    end    
    rac = RoleActivityConcept.destroy_all
    
    unless Role.find_by_name("Admin")
      Role.create! :name=> "Admin"
    end
    unless Role.find_by_name("Default")
      Role.create! :name=> "Default"
    end
    unless Role.find_by_name("Local Admin")
      Role.create! :name=> "Local Admin"
    end
    unless Role.find_by_name("CSR")
      Role.create! :name=> "CSR"
    end
    unless Role.find_by_name("Sales")
      Role.create! :name=> "Sales"
    end
    unless Role.find_by_name("Accounting")
      Role.create! :name=> "Accounting"
    end
    
    unless Activity.find_by_name("View")
      Activity.create! :name=> "View"
    end
    unless Activity.find_by_name("Update")
      Activity.create! :name=> "Update"
    end
    unless Activity.find_by_name("Create")
      Activity.create! :name=> "Create"
    end
    unless Activity.find_by_name("Pose")
      Activity.create! :name=> "Pose"
    end
    
    unless Concept.find_by_name("Contract")
      Concept.create! :name=> "Contract"
    end
    unless Concept.find_by_name("Role")
      Concept.create! :name=> "Role"
    end    
    unless Concept.find_by_name("Group")
      Concept.create! :name=> "Group"
    end  
    unless Concept.find_by_name("Advertiser")
      Concept.create! :name=> "Advertiser"
    end
    unless Concept.find_by_name("Offer")
      Concept.create! :name=> "Offer"
    end
    unless Concept.find_by_name("Group")
      Concept.create! :name=> "Group"
    end
    unless Concept.find_by_name("Category")
      Concept.create! :name=> "Category"
    end
    unless Concept.find_by_name("Affiliate")
      Concept.create! :name=> "Affiliate"
    end
    unless Concept.find_by_name("Invoice")
      Concept.create! :name=> "Invoice"
    end
    unless Concept.find_by_name("Payment")
      Concept.create! :name=> "Payment"
    end    
    unless Concept.find_by_name("User")
      Concept.create! :name=> "User"
    end    
    unless Concept.find_by_name("Plan")
      Concept.create! :name=> "Plan"
    end 
    unless Concept.find_by_name("Contract Plan")
      Concept.create! :name=> "Contract Plan"
    end 
    unless Concept.find_by_name("Discount")
      Concept.create! :name=> "Discount"
    end
    unless Concept.find_by_name("Feature")
      Concept.create! :name=> "Feature"
    end
    unless Concept.find_by_name("GroupContractPlan")
      Concept.create! :name=> "GroupContractPlan"
    end
    cs = Concept.all
    as = Activity.all
    cs.each do |c|
      as.each do |a|
        unless c.activities.index(a)
          unless a.name == "Pose"
            c.activities << a
            c.save
          else
            if c.name == "User"
              c.activities << a
              c.save
            end
          end
        end
          unless a.name == "Pose" and c.name != "User"
            Role::ADMIN.role_activity_concepts.create(:concept => c, :activity => a) 
          if c.name != "Role" and c.name != "Group"
            Role::LOCAL_ADMIN.role_activity_concepts.create(:concept => c, :activity => a) 
          end
        end
        if (c.name == "Offer" or c.name == "Advertiser" or c.name == "Contract" or c.name == "Invoice" or c.name == "User") and a.name == "View"
          Role.find_by_name("Sales").role_activity_concepts.create(:concept => c, :activity => a) 
          Role.find_by_name("CSR").role_activity_concepts.create(:concept => c, :activity => a) 
          Role.find_by_name("Accounting").role_activity_concepts.create(:concept => c, :activity => a) 
        end
        if c.name == "User" and a.name == "Pose"
          Role.find_by_name("Sales").role_activity_concepts.create(:concept => c, :activity => a) 
          Role.find_by_name("CSR").role_activity_concepts.create(:concept => c, :activity => a)  
          Role.find_by_name("Accounting").role_activity_concepts.create(:concept => c, :activity => a)
        end
        if ((c.name == "Invoice")  and  (a.name == "Create" or a.name == "Update")) or (c.name == "Payment" and a.name != "Pose")
          Role.find_by_name("Accounting").role_activity_concepts.create(:concept => c, :activity => a)
        end
      end
    end
  end

  def self.down
  end
end