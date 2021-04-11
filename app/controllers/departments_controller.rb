# frozen_string_literal: true

class DepartmentsController < ApplicationController
  def new; end

  def index
    @departments = Department.all
  end

  def show
    @department = Department.find(params[:id])
  end

  def edit; end

  def create; end

  def delete; end

  def destroy; end
end
