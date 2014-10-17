json.id round.id
json.state round.state
json.genre round.genre

json.nominations round.nominations, :partial => 'partials/nomination', :as => :nomination

if current_user
  json.my_nominations round.nominations.by_user(current_user.id), :partial => 'partials/nomination', :as => :nomination
  json.selections(round.selections(current_user),
                  :partial => 'partials/selection',
                  :as => :selection)
end

json.created_at round.created_at
json.updated_at round.updated_at
json.nominating_at round.nominating_at
json.seconding_at round.seconding_at
json.reading_at round.reading_at
json.closed_at round.closed_at
