# frozen_string_literal: true

class DepartmentsController < ApplicationController
  def new
    @department = Department.new
  end

  def index
    @departments = Department.all
  end

  def show
    @department = Department.find(params[:id])
  end

  def edit
    if !current_user.roles.include?(Role.admin_role) &&
       !current_user.roles.include?(Role.tutor_role)
      redirect_to "/users/#{current_user.id}"
    end
  end

  def create
    @department = Department.new(params[:departments])
    if @department.save
      flash[:success] = 'department saved!'
      redirect_to @department
    else
      flash[:alert] = 'department not saved!'
    end
  end

  def delete; end

  def destroy; end
end
