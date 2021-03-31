# frozen_string_literal: true

class SpartanSessionsController < ApplicationController
  before_action :check_first_code, only: [:check_in_first]
  before_action :check_second_code, only: [:check_in_second]

  def check_in_first
    SpartanSessionUser.create(spartan_session_id: params[:sessionID],
                              user_id: current_user.id,
                              first_checkin: Time.zone.now)

    redirect_to "/users/#{current_user.id}"
  end

  def check_in_second
    session = SpartanSessionUser.where(spartan_session_id: params[:sessionID])
                                .and(SpartanSessionUser.where(user_id: current_user.id))
                                .first
    session.update(second_checkin: Time.zone.now)

    redirect_to "/users/#{current_user.id}"
  end

  private

  def check_first_code
    unless SpartanSession.find(params[:sessionID]).first_code ==
           params[:spartan_session_user][:code]
      flash.alert = 'Invalid check in code!'
      redirect_to "/users/#{current_user.id}"
    end
  end

  def check_second_code
    unless SpartanSession.find(params[:sessionID]).second_code ==
           params[:spartan_session_user][:code]
      flash.alert = 'Invalid check in code!'
      redirect_to "/users/#{current_user.id}"
    end
  end
end
