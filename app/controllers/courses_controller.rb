# frozen_string_literal: true

class CoursesController < ApplicationController
  def new; end

  def edit; end

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end
end
