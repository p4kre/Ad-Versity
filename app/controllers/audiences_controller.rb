class AudiencesController < ApplicationController
  before_action :set_audience, only: [:show, :edit, :update, :destroy, :sync_to_meta, :add_contacts, :remove_contact]

  def index
    @audiences = Audience.all
    @audiences = @audiences.search(params[:search]) if params[:search].present?
    @audiences = @audiences.by_status(params[:status]) if params[:status].present?
    @audiences = @audiences.order(:name)
  end

  def show
  end

  def new
    @audience = Audience.new(status: :draft)
  end

  def create
    @audience = Audience.new(audience_params)
    @audience.status ||= :draft

    if @audience.save
      redirect_to @audience, notice: "Audience created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @audience.update(audience_params)
      redirect_to @audience, notice: "Audience updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @audience.destroy
    redirect_to audiences_path, notice: "Audience deleted successfully."
  end

  # ⭐ Custom action — Trigger background sync job
  def sync_to_meta
    AudienceSyncWorker.perform_async(@audience.id)
    @audience.update(status: :syncing)

    redirect_to @audience, notice: "Audience sync started. Check status shortly."
  end

  def add_contacts
    if request.get?
      # Start with all contacts, excluding those already in audience
      @contacts = Contact.where.not(id: @audience.contact_ids).order(:first_name, :last_name)
      @audience_contact_ids = @audience.contact_ids
      
      # Apply demographic filters
      @contacts = @contacts.by_age_range(params[:filter_age_range]) if params[:filter_age_range].present?
      @contacts = @contacts.by_gender(params[:filter_gender]) if params[:filter_gender].present?
      @contacts = @contacts.by_income_range(params[:filter_income_range]) if params[:filter_income_range].present?
      @contacts = @contacts.by_education_level(params[:filter_education_level]) if params[:filter_education_level].present?
      @contacts = @contacts.by_occupation(params[:filter_occupation]) if params[:filter_occupation].present?
      @contacts = @contacts.by_marital_status(params[:filter_marital_status]) if params[:filter_marital_status].present?
      @contacts = @contacts.by_family_status(params[:filter_family_status]) if params[:filter_family_status].present?
      
      # Store filter params for form
      @filter_params = {
        age_range: params[:filter_age_range],
        gender: params[:filter_gender],
        income_range: params[:filter_income_range],
        education_level: params[:filter_education_level],
        occupation: params[:filter_occupation],
        marital_status: params[:filter_marital_status],
        family_status: params[:filter_family_status]
      }
      
      # Get demographic suggestions if audience has contacts
      if @audience.contacts.any?
        matcher = DemographicMatcher::Service.new(@audience)
        @suggested_contacts = matcher.suggest_contacts(limit: 10)
        @demographics = matcher.analyze_audience_demographics
      else
        @suggested_contacts = []
        @demographics = {}
      end
    elsif request.post?
      contact_ids = params[:contact_ids] || []
      # Filter out empty strings and convert to integers
      contact_ids = contact_ids.reject(&:blank?).map(&:to_i).reject(&:zero?)
      
      if contact_ids.any?
        added_count = 0
        contact_ids.each do |contact_id|
          begin
            contact = Contact.find(contact_id)
            unless @audience.contacts.include?(contact)
              @audience.contacts << contact
              added_count += 1
            end
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error "Contact not found: #{contact_id}"
          end
        end
        
        if added_count > 0
          redirect_to @audience, notice: "#{added_count} contact(s) added successfully."
        else
          redirect_to add_contacts_audience_path(@audience), alert: "No new contacts were added. They may already be in this audience."
        end
      else
        redirect_to add_contacts_audience_path(@audience), alert: "Please select at least one contact to add."
      end
    end
  end

  def remove_contact
    contact = Contact.find(params[:contact_id])
    @audience.contacts.delete(contact)
    redirect_to @audience, notice: "Contact removed from audience."
  end

  private

  def set_audience
    @audience = Audience.find(params[:id])
  end

  def audience_params
    params.require(:audience).permit(:name, :description, :status)
  end
end
