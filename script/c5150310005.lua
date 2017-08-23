--Black Prismelon Diamelon
--AlphaKretin
function c5150310005.initial_effect(c)
	--cannot be NS/Set
	c:EnableUnsummonable()
	--SS from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c5150310005.spcon)
	e1:SetOperation(c5150310005.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c5150310005.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5150310005,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(3)
	e3:SetCondition(c5150310005.thcon)
	e3:SetTarget(c5150310005.thtg)
	e3:SetOperation(c5150310005.thop)
	c:RegisterEffect(e3)
	--revive
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5150310005,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EVENT_FLAG_DELAY)
	e4:SetCondition(c5150310005.revcon)
	e4:SetCost(c5150310005.revcost)
	e4:SetTarget(c5150310005.revtg)
	e4:SetOperation(c5150310005.revop)
	c:RegisterEffect(e4)
end
function c5150310005.spfilter1(c)
	return c:IsSetCard(0xf31) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c5150310005.spfilter2,tp,LOCATION_GRAVE,0,1,nil,c:GetAttribute())
end
function c5150310005.spfilter2(c,attr)
	return c:IsSetCard(0xf31) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:GetAttribute()~=attr
end
function c5150310005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c5150310005.spfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c5150310005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c5150310005.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c5150310005.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,g1:GetFirst():GetAttribute())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c5150310005.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and not c:IsAttribute(ATTRIBUTE_DARK) and aux.checksamecolumn(c,e:GetHandler())
end
function c5150310005.thcfilter(c)
	return c:IsSetCard(0xf31)
end
function c5150310005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5150310005.thcfilter,1,nil)
end
function c5150310005.thfilter(c)
	return c:IsSetCard(0xf31) and c:IsAbleToHand()
end
function c5150310005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5150310005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5150310005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5150310005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c5150310005.revcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c5150310005.revcostfilter(c,attr)
	return c:IsSetCard(0xf31) and not c:IsAttribute(attr) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c5150310005.revcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c5150310005.revcostfilter,tp,LOCATION_GRAVE,0,1,c,c:GetAttribute()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c5150310005.revcostfilter,tp,LOCATION_GRAVE,0,1,1,c,c:GetAttribute())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c5150310005.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c5150310005.revop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end