class OrganisationsController < ApplicationController
  
  around_filter :neo_tx
  layout 'layout'
  
  def index
    @organisations = Organisation.all.nodes
  end
  
  def create
    @object = Organisation.new
    @object.update(params[:organisation])
    flash[:notice] = 'Organisation was successfully created.'
    redirect_to(organisations_url)
  end
  
  def update
    @object.update(params[:organisation])
    flash[:notice] = 'Organisation was successfully updated.'
    redirect_to(@object)
  end
  
  def destroy
    @object.delete
    redirect_to(organisations_url)
  end
  
  def edit
  end
  
  def show
    @references = Reference.all.nodes
    @organisations = Organisation.all.nodes
    @people = Person.all.nodes
    @locations = Location.all.nodes
    @events = Event.all.nodes

  end

  def link
    linker(params)
    redirect_to(@object)
    flash[:notice] = @object.name + " was linked to node " + @target.neo_node_id.to_s
  end
  
  def unlink
    unlinker(params)
    redirect_to(@object)
    flash[:notice] = @object.name + " was unlinked from " + @target.neo_node_id.to_s
  end
  
  def new
    @object = Organisation.value_object.new
  end
  
  private
  def neo_tx
    Neo4j::Transaction.new
    @object = Neo4j.load(params[:id]) if params[:id]
    yield
    Neo4j::Transaction.finish
  end
end