# -*- encoding: utf-8 -*-

class CorpStatesController < ApplicationController
  # GET /corp_states
  # GET /corp_states.json
  def index
    @corp_states = CorpState.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @corp_states }
    end
  end

  # GET /corp_states/1
  # GET /corp_states/1.json
  def show
    @corp_state = CorpState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @corp_state }
    end
  end

  # GET /corp_states/new
  # GET /corp_states/new.json
  def new
    @corp_state = CorpState.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @corp_state }
    end
  end

  # GET /corp_states/1/edit
  def edit
    @corp_state = CorpState.find(params[:id])
  end

  # POST /corp_states
  # POST /corp_states.json
  def create
    @corp_state = CorpState.new(params[:corp_state])

    respond_to do |format|
      if @corp_state.save
        format.html { redirect_to @corp_state, notice: 'Corp state was successfully created.' }
        format.json { render json: @corp_state, status: :created, location: @corp_state }
      else
        format.html { render action: "new" }
        format.json { render json: @corp_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /corp_states/1
  # PUT /corp_states/1.json
  def update
    @corp_state = CorpState.find(params[:id])

    respond_to do |format|
      if @corp_state.update_attributes(params[:corp_state])
        format.html { redirect_to @corp_state, notice: 'Corp state was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @corp_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corp_states/1
  # DELETE /corp_states/1.json
  def destroy
    @corp_state = CorpState.find(params[:id])
    @corp_state.destroy

    respond_to do |format|
      format.html { redirect_to corp_states_url }
      format.json { head :no_content }
    end
  end
end
