json.id round.id
json.state round.state

json.nominations round.nominations, :partial => 'partials/nomination', :as => :nomination

json.created_at round.created_at
json.updated_at round.updated_at
