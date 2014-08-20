class User < ActiveRecord::Base
	has_many :tests
	has_many :results
end

class Test < ActiveRecord::Base
	belongs_to :user
	has_many :questions
	has_many :results
end

class Question < ActiveRecord::Base
	belongs_to :test
	has_many :answers
end

class Answer < ActiveRecord::Base
	belongs_to :question
end

class Result < ActiveRecord::Base
	belongs_to :user
	belongs_to :test
end
