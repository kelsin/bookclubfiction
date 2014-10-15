json.id round.id
json.state round.state

json.nominations round.nominations, :partial => 'partials/nomination', :as => :nomination

if current_user
  json.selections(round.selections(current_user),
                  :partial => 'partials/selection',
                  :as => :selection)
end

json.created_at round.created_at
json.updated_at round.updated_at
