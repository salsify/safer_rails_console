# frozen_string_literal: true

require_relative '../../contexts/db_sandbox'

describe "Integration: patches/sandbox" do
  include_context "db sandbox context"

  context "for PostgreSQL" do
    it_behaves_like "auto_rollback"
    it_behaves_like "read_only"
  end

  context "for Mysql" do
    let(:adapter) { :mysql2 }

    it_behaves_like "auto_rollback"
    it_behaves_like "read_only"
  end
end
