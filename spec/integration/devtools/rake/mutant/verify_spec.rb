describe Devtools::Rake::Mutant, '#verify' do
  subject(:instance) { described_class.new(config) }

  let(:expect_coverage) { 1           }
  let(:ignore_subjects) { []          }
  let(:name)            { 'foo'       }
  let(:namespace)       { 'Foo'       }
  let(:since)           { nil         }
  let(:strategy)        { 'fancy'     }
  let(:zombify)         { false       }
  let(:mutant_cli)      { Mutant::CLI }
  let(:status)          { 0           }

  let(:config) do
    instance_double(
      Devtools::Config::Mutant,
      expect_coverage: expect_coverage,
      ignore_subjects: ignore_subjects,
      name:            name,
      namespace:       namespace,
      since:           since,
      strategy:        strategy,
      zombify:         zombify
    )
  end

  let(:arguments) do
    %W[
      --include         lib
      --require         #{name}
      --expect-coverage #{expect_coverage}
      --use             #{strategy}
      Foo*
    ]
  end

  before do
    allow(mutant_cli).to receive(:run).and_return(status)
  end

  shared_examples_for 'a mutant task' do
    it 'translates configuration to CLI arguments' do
      instance.verify
      expect(mutant_cli).to have_received(:run).with(arguments)
    end
  end

  context 'when ignores subjects' do
    let(:ignore_subjects) { %w[Foo.bar Foo#baz] }
    let(:arguments) do
      %W[
        --include         lib
        --require         #{name}
        --expect-coverage #{expect_coverage}
        --use             #{strategy}
        --ignore          Foo.bar
        --ignore          Foo#baz
        Foo*
      ]
    end

    it_behaves_like 'a mutant task'
  end

  context 'when specifies since' do
    let(:since) { '0cecada' }

    let(:arguments) do
      %W[
        --include         lib
        --require         #{name}
        --expect-coverage #{expect_coverage}
        --use             #{strategy}
        Foo*
        --since           #{since}
      ]
    end

    it_behaves_like 'a mutant task'
  end

  context 'when multiple namespaces' do
    let(:namespace) { %w[Foo Bar] }

    let(:arguments) do
      %W[
        --include         lib
        --require         #{name}
        --expect-coverage #{expect_coverage}
        --use             #{strategy}
        Foo*
        Bar*
      ]
    end

    it_behaves_like 'a mutant task'
  end

  context 'when zombify is enabled' do
    let(:zombify) { true }

    let(:arguments) do
      %W[
        --include         lib
        --require         #{name}
        --expect-coverage #{expect_coverage}
        --use             #{strategy}
        Foo*
        --zombify
      ]
    end

    it_behaves_like 'a mutant task'
  end

  context 'when exit status is nonzero' do
    let(:status) { 1 }

    it 'fails with metric violation' do
      expect { instance.verify }
        .to raise_error(SystemExit).with_message('Mutant task is not successful')
    end
  end
end
