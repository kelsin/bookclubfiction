json.state round.state
json.created_at round.created_at
json.updated_at round.updated_at
json.nominations round.nominations, :partial => 'partials/nomination', :as => :nomination
