# frozen_string_literal: true

class DepartmentsController < ApplicationController
  def new
    @department = Departments.new
  end

  def index
    @departments = Departments.all
  end

  def show
    @department = Departments.find(params[:id])
  end

  def edit
    if !current_user.roles.include?(Role.admin_role) &&
       !current_user.roles.include?(Role.tutor_role)
      redirect_to "/users/#{current_user.id}"
    end
  end

  def create
    @department = Departments.new(params[:departments])
    if @department.save
      flash[:success] = 'department saved!'
    else
      flash[:alert] = 'department not saved!'
    end
  end
end
