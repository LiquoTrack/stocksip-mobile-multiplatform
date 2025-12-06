abstract class SubscriptionEvent {
  const SubscriptionEvent();
}

class OnCreateInitialSubscription extends SubscriptionEvent {
  final String selectedPlanId;
  const OnCreateInitialSubscription(this.selectedPlanId);
}

class GetSubscriptionByAccountId extends SubscriptionEvent {
  const GetSubscriptionByAccountId();
}

class OnUpgradeSubscription extends SubscriptionEvent {
  final String subscriptionId;
  final String newPlanId;
  const OnUpgradeSubscription(this.subscriptionId, this.newPlanId);
}

class ClearInitPoint extends SubscriptionEvent {
  const ClearInitPoint();
}