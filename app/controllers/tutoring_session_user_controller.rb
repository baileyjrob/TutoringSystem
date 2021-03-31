# frozen_string_literal: true

class TutoringSessionUserController < ApplicationController
  before_action :authenticate_user!

  def show
    @pending_links = TutoringSessionUser.joins(:tutoring_session)
                                        .where(tutoring_session: { tutor_id: current_user.id })
                                        .where(link_status: 'pending')
  end

  def confirm_pending_link
    link = TutoringSessionUser.find(params[:id])
    link.link_status = 'confirmed'
    link.save

    redirect_to action: 'show'
  end

  def deny_pending_link
    link = TutoringSessionUser.find(params[:id])
    link.link_status = 'denied'
    link.save

    redirect_to action: 'show'
  end
end
