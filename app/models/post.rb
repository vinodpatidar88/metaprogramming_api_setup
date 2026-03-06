class Post < ApplicationRecord
   enum :status, {inactive: 0, active: 1, in_progress: 0}
end