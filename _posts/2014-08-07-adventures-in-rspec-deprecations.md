---
layout: post
title:  "Adventures in RSpec Deprecations"
date:   2014-08-07 15:00:00
post_author: Zach Morek
---

We were going through a bundle upgrade and updated RSpec along the way.
Some of our legacy code has some very complex behavior that we're testing using stubs.
Turns out that the [Law of Demeter](https://en.wikipedia.org/wiki/Law_Of_Demeter) is a lot easier to break than the [Laws of Thermodynamics](https://en.wikipedia.org/wiki/Laws_of_thermodynamics).
Rather than get caught up trying to unwind the test, we were hoping to fix our deprecation warnings and move onto making features that our customers care about.

Our test was using `stub_chain` and thus needed to be updated.

```ruby
describe 'A test that uses stub chains' do
  it 'gets a deprecation warning' do
    complex_model = FactoryGirl.create(:complex_model)
    complex_model.stub_chain(:complex_parent_model, :to_xml).
      and_return(complex_model.to_xml)
    # This is line needs to get updated ^

    complex_model.related_models << FactoryGirl.build(:related_model)
    complex_model.save!

    expect {
      complex_model.destroy_related_models_not_in_parent_xml!
    }.to change(complex.model.related_models, :count).by(-1)
  end
end
```

We looked at the docs for 3.0:
[Message Chains - Working with legacy code - RSpec Mocks - RSpec - Relish](https://relishapp.com/rspec/rspec-mocks/v/3-0/docs/working-with-legacy-code/message-chains)

We saw the related docs in 2.99:
[stub a chain of methods - Method stubs - RSpec Mocks - RSpec - Relish](https://relishapp.com/rspec/rspec-mocks/v/2-99/docs/method-stubs/stub-a-chain-of-methods)

We then decided to update the test to match the docs as closely as possible.

```ruby
describe 'A test that now uses message chains' do
  it 'fails mysteriously' do
    complex_model = FactoryGirl.create(:complex_model)
    allow(complex_model).to receive_message_chain(:complex_parent_model, :to_xml)
      { complex_model.to_xml }
    # Yay! We should be good to go! ^

    complex_model.related_models << FactoryGirl.build(:related_model)
    complex_model.save!

    expect {
      complex_model.destroy_related_models_not_in_parent_xml!
    }.to change(complex.model.related_models, :count).by(-1)
  end
end
```

Aaaaaand then our tests broke.
We just couldn't figure out what was wrong.

![AHHHHHHHHHH!](/images/angry_shake.gif)

And then it dawned on us.

![OOOOOOOOOOH!](/images/sudden_realization.gif)

We realized that by changing from `and_return` to a block we were throwing off the xml representation of our `complex_model`.
We wanted a snapshot of `complex_model.to_xml` instead of a fresh version every time.
In a real situation, the `complex_parent_model` would not have this problem.
We were using a block that would evaluate new every time.

![Sonofa](/images/bee_sting.gif)

Once we changed it back to using the method, we were good to go again.

```ruby
describe 'A test that now uses message chains and return' do
  it 'works just right' do
    complex_model = FactoryGirl.create(:complex_model)
    allow(complex_model).to receive_message_chain(:complex_parent_model, :to_xml).
      and_return(complex_model.to_xml)
    # Rock on! ^

    complex_model.related_models << FactoryGirl.build(:related_model)
    complex_model.save!

    expect {
      complex_model.destroy_related_models_not_in_parent_xml!
    }.to change(complex.model.related_models, :count).by(-1)
  end
end
```

Turns out there's a lot of different options for returning: [Configuring responses - RSpec Mocks - RSpec - Relish](https://www.relishapp.com/rspec/rspec-mocks/v/3-0/docs/configuring-responses)

![Nice](/images/thumbs_up.gif)

:wq
