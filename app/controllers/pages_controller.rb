class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[impressum contact]
  def impressum
  end

  def contact
  end
end
