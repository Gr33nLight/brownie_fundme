from scripts.utils import get_account, deploy_mocks
from brownie import network, config, FundMe, MockV3Aggregator


def deploy_fund_me():
    account = get_account()
    is_dev = network.show_active() == "development"

    if not is_dev:
        price_feed_addr = config["networks"][network.show_active()]["price_feed_addr"]
    else:
        print("Deploying Mocks...")
        deploy_mocks()
        price_feed_addr = MockV3Aggregator[-1].address
        print("Mocks deployed")

    fund_me = FundMe.deploy(
        price_feed_addr,
        {"from": account},
        publish_source=(config["networks"][network.show_active()].get("verify")),
    )
    print(f"Contract deployed to {fund_me.address}")


def main():
    deploy_fund_me()
    pass
