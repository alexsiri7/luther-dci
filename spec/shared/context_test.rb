
shared_context 'context test' do
  subject do
    described_class.new all_params
  end

  def call_method
    subject.call
  end

  let(:success) { -> context {} }
  let(:failure) { -> context {} }
  let(:all_params) {
    params.merge({
      success: success,
      failure: failure
    })
  }
end

shared_examples 'calls callback' do |callback|
  it "calls #{callback}" do
    (send callback).should_receive(:call).with(subject)
    call_method
  end
end

shared_examples 'does not call callback' do |callback|
  it "does not call #{callback}" do
    (send callback).should_not_receive(:call)
    call_method
  end
end
