class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
         
  has_many :comments

  def self.from_omniauth(auth)  
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.nombre = auth.info.name
      user.foto_url = auth.info.image
      user.password = Devise.friendly_token[0,20]
    end
  end

  ratyrate_rater
  validates :saldo, :numericality => { :greater_than_or_equal_to => 0 }
  validates :email, presence: true
  validates :password, presence: true
  
end
